from pydantic import BaseModel
from typing import Optional

class CreatePatientPayload(BaseModel):
    name: str
    userId: str

class CreateSessionPayload(BaseModel):
    patientId: str
    userId: str
    patientName: Optional[str] = None
    status: Optional[str] = "recording"
    startTime: Optional[str] = None
    templateId: Optional[str] = None

class PresignedRequest(BaseModel):
    sessionId: str
    chunkNumber: int
    mimeType: str

class NotifyChunkPayload(BaseModel):
    sessionId: str
    gcsPath: str
    chunkNumber: int
    isLast: bool
    totalChunksClient: Optional[int] = None
    publicUrl: Optional[str] = None
    mimeType: Optional[str] = None
    selectedTemplate: Optional[str] = None
    selectedTemplateId: Optional[str] = None
    model: Optional[str] = None
