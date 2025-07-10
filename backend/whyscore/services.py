
import os
from openai import OpenAI
from whyscore.models import WhyAnalysisRequest

client = OpenAI(
    api_key=os.getenv("OPENROUTER_API_KEY"),
    base_url="https://openrouter.ai/api/v1"
)

def escolher_modelo(preferido: str = None) -> str:
    """
    Mapeia alias para o identificador de modelo na OpenRouter/OpenAI/Anthropic.
    Se nenhum alias for passado, retorna o Mistral gratuito por padrão.
    """
    modelos_disponiveis = {
        "mistral": "qwen/qwen-2.5-coder-32b-instruct:free",
        "gpt3":    "openai/gpt-3.5-turbo",
        "gpt4":    "openai/gpt-4",
        "claude":  "anthropic/claude-3-sonnet",
        "gemini":  "google/gemini-2.0-flash-exp:free",
        "meta":    "meta-llama/llama-3.1-8b-instruct:free",
    }
    return modelos_disponiveis.get(preferido, modelos_disponiveis["mistral"])


def analisar_falha(input_data: WhyAnalysisRequest, db, modelo_usuario: str = None):
    """
    Executa a análise de causa raiz via IA, usando o modelo escolhido.
    - input_data.failure: a descrição da falha
    - modelo_usuario: opcional, alias do modelo a usar (ex: "gpt3", "gpt4", "claude", "gemini", "meta")
    """
    prompt = f"""
    A partir da seguinte descrição de falha, realize uma análise utilizando a metodologia dos 5 Porquês.
    Para cada nível, apresente uma pergunta e uma resposta técnica plausível, até chegar à causa raiz.

    Falha: {input_data.failure}

    Formato da resposta:
    - Porquê 1: [pergunta e resposta]
    - Porquê 2: [pergunta e resposta]
    - Porquê 3: [pergunta e resposta]
    - Porquê 4: [pergunta e resposta]
    - Porquê 5: [pergunta e resposta]
    - Causa raiz provável: [resumo]
    """

    try:
        # Seleciona o modelo dinamicamente
        model = escolher_modelo(modelo_usuario)

        response = client.chat.completions.create(
            model=model,
            messages=[
                {
                    "role": "system",
                    "content": "Você é um engenheiro especialista em análise de falhas usando a metodologia dos 5 Porquês."
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            temperature=0.5,
            max_tokens=600
        )

        # Extrai e ajusta o texto de resposta
        resposta = response.choices[0].message.content.strip()
        resposta = resposta.encode('utf-8').decode('utf-8')

        # Quebra em linhas não vazias
        raw = [linha.strip() for linha in resposta.split("\n") if linha.strip()]

        # Agrupa pergunta e resposta em um único bloco
        blocos = []
        bloco_atual = ""
        for linha in raw:
            lower = linha.lower()
            if lower.startswith("- porquê") or lower.startswith("- causa"):
                if bloco_atual:
                    blocos.append(bloco_atual.strip())
                bloco_atual = linha
            else:
                bloco_atual += " " + linha
        if bloco_atual:
            blocos.append(bloco_atual.strip())

        return {
            "input": input_data.failure,
            "analise": blocos,
            "mensagem": "Análise realizada com sucesso com base nos 5 porquês."
        }

    except Exception as e:
        return {
            "input": input_data.failure,
            "analise": [],
            "mensagem": f"Erro na análise: {str(e)}"
        }



