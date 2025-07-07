from fastapi import APIRouter, Request, HTTPException
from whyscore.models import WhyAnalysisRequest
from whyscore.services import analisar_falha

router = APIRouter()

@router.post("/analisar")
async def rota_analisar(request: Request):
    payload = await request.json()
    failure = payload.get("failure")
    modelo  = payload.get("modelo")

    if not failure:
        raise HTTPException(status_code=400, detail="Campo 'failure' ausente")

    req = WhyAnalysisRequest(failure=failure)
    resultado = analisar_falha(req, db=None, modelo_usuario=modelo)

    return {
        "analise": resultado["analise"],    # será List<String>
        "mensagem": resultado["mensagem"]   # será String
    }




