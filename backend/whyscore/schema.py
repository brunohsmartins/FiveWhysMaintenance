from sqlalchemy import Column, Integer, String, DateTime
from .database import Base
import datetime

class WhyAnalysis(Base):
    __tablename__ = "why_analyses"

    id         = Column(Integer, primary_key=True, index=True)
    failure    = Column(String, nullable=False)
    whys       = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
