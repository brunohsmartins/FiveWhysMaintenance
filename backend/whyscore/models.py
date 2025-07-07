from pydantic import BaseModel
from typing import List, Optional

class WhyAnalysisRequest(BaseModel):
    failure: str
    checks: Optional[List[str]] = []
