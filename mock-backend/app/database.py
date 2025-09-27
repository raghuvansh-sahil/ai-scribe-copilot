import uuid
from datetime import datetime, timedelta, timezone
import random

db = {
    "patients": {},
    "sessions": {}
}

names = [
    "Alice Johnson", "Bob Smith", "Charlie Brown", "Diana Prince",
    "Ethan Hunt", "Fiona Gallagher", "George Lucas", "Hannah Baker",
    "Ian McKellen", "Jane Doe", "Kevin Hart", "Laura Palmer",
    "Michael Scott", "Nina Williams", "Oscar Isaac", "Pam Beesly",
    "Quentin Blake", "Rachel Green", "Sam Winchester", "Tina Turner"
]

for i, name in enumerate(names, start=1):
    patient_id = f"patient_{str(uuid.uuid4())[:8]}"
    user_id = f"user_{(i % 5) + 1}"  # 5 different users
    db["patients"][patient_id] = {
        "id": patient_id,
        "name": name,
        "user_id": user_id,
        "pronouns": random.choice([None, "he/him", "she/her", "they/them"])
    }

session_titles = [
    "General Checkup", "Cardiology Follow-up", "Orthopedic Consultation",
    "Therapy Session", "Diabetes Management", "Surgery Review",
    "Dermatology Appointment", "Neurology Consultation", "Annual Physical Exam"
]

for patient_id, patient in db["patients"].items():
    for _ in range(random.randint(3, 10)): 
        session_id = f"session_{str(uuid.uuid4())[:8]}"
        start_time = datetime.now(timezone.utc) - timedelta(days=random.randint(1, 365))
        db["sessions"][session_id] = {
            "id": session_id,
            "user_id": patient["user_id"],
            "patient_id": patient_id,
            "date": start_time.date().isoformat(),
            "session_title": random.choice(session_titles),
            "session_summary": random.choice([
                "Patient reported mild symptoms.",
                "Follow-up recommended in two weeks.",
                "Treatment plan adjusted.",
                "Blood tests ordered.",
                "Patient feeling much better."
            ]),
            "status": random.choice(["completed", "recording", "in-progress"]),
            "start_time": start_time.isoformat(),
            "end_time": (start_time + timedelta(hours=1)).isoformat()
        }
