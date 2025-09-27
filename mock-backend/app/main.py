from fastapi import FastAPI, Header, HTTPException, Path, Query
from typing import Optional
from datetime import datetime, timezone
import uuid

from .utility import check_auth
from .database import db
from .schemas import CreatePatientPayload, CreateSessionPayload, PresignedRequest, NotifyChunkPayload

app = FastAPI(title="MediNote Mock Backend", version="1.0.0")

@app.get("/v1/patients")
def get_patients(userId: str = Query(..., description="User database ID"), Authorization: Optional[str] = Header(None)):
    check_auth(Authorization)
    patients = []
    for p in db["patients"].values():
        if p["user_id"] == userId:
            patients.append({"id": p["id"], "name": p["name"]})
    return {"patients": patients}

@app.post("/v1/add-patient-ext", status_code=201)
def create_patient(payload: CreatePatientPayload, Authorization: Optional[str] = Header(None)):
    check_auth(Authorization)
    new_id = f"patient_{str(uuid.uuid4())[:8]}"
    patient = {
        "id": new_id,
        "name": payload.name,
        "user_id": payload.userId,
        "pronouns": None
    }
    db["patients"][new_id] = patient
    return {"patient": patient}

@app.get("/v1/fetch-session-by-patient/{patientId}")
def get_sessions_by_patient(patientId: str = Path(...), Authorization: Optional[str] = Header(None)):
    check_auth(Authorization)
    sessions = []
    for s in db["sessions"].values():
        if s["patient_id"] == patientId:
            sessions.append({
                "id": s["id"],
                "date": s.get("date"),
                "session_title": s.get("session_title"),
                "session_summary": s.get("session_summary"),
                "start_time": s.get("start_time")
            })
    return {"sessions": sessions}

@app.post("/v1/upload-session", status_code=201)
def upload_session(payload: CreateSessionPayload, Authorization: Optional[str] = Header(None)):
    check_auth(Authorization)
    new_id = f"session_{str(uuid.uuid4())[:8]}"
    session = {
        "id": new_id,
        "user_id": payload.userId,
        "patient_id": payload.patientId,
        "session_title": payload.templateId or "Untitled",
        "session_summary": "",
        "status": payload.status or "recording",
        "start_time": payload.startTime or datetime.now(timezone.utc).isoformat(),
    }
    db["sessions"][new_id] = session
    
    return session  

@app.post("/v1/get-presigned-url")
def get_presigned(req: PresignedRequest, Authorization: Optional[str] = Header(None)):
    check_auth(Authorization)
    # This mock returns a fake signed URL and paths. In real life you'd call GCS SDK to sign.
    gcs_path = f"sessions/{req.sessionId}/chunk_{req.chunkNumber}.wav"
    url = f"https://mock-storage.local/{gcs_path}"
    public_url = f"https://storage.googleapis.com/mock-bucket/{gcs_path}"
    return {"url": url, "gcsPath": gcs_path, "publicUrl": public_url}

@app.post("/v1/notify-chunk-uploaded")
def notify_chunk_uploaded(payload: NotifyChunkPayload, Authorization: Optional[str] = Header(None)):
    check_auth(Authorization)
    # For mock, just record that chunk arrived; if isLast = true, mark session completed.
    session = db["sessions"].get(payload.sessionId)
    if not session:
        # Not found -> create lightweight record to be forgiving in tests
        db["sessions"][payload.sessionId] = {"id": payload.sessionId, "patient_id": payload.sessionId, "user_id": "unknown"}
    if payload.isLast:
        s = db["sessions"][payload.sessionId]
        s["status"] = "completed"
        s["end_time"] = datetime.now(timezone.utc).isoformat()
    return {}

# Root
@app.get("/")
def root():
    return {"message": "MediNote Mock API - FastAPI", "version": "1.0.0"}