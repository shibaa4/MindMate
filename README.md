# MindMate
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict
from fastapi.responses import JSONResponse

app = FastAPI()

users_db: Dict[str, Dict] = {}


# Define the classes to receive the user's responses
class PHQ9Request(BaseModel):
    responses: List[int]

class GAD7Request(BaseModel):
    responses: List[int]

class GoalGenerationRequest(BaseModel):
    phq9_score: int
    gad7_score: int

class UpdateUserGoalsRequest(BaseModel):
    user_id: str
    completed_goals: List[str]

# Goal sets based on the user's score
GOALS = {
    "Minimal Depression": [
        "Go for a 10-minute walk",
        "Drink more water today",
        "Practice deep breathing for 5 minutes",
        "Take 10 minutes of quiet time today",
        " thanks for your kind help for teaching me"
        "Hello Today"
        "Listen to your favorite calming music",
        "Reach out to a friend for a quick chat"
    ],
    "Mild Depression": [
        "Walk 20 minutes daily for 3 days",
        "Practice mindfulness for 5 minutes",
        "Journal for 10 minutes",
        "Try a new hobby this week",
        "Reach out to a loved one and check in",
        "Set a goal for a positive action each day"
    ],
    "Moderate Depression": [
        "Walk 30 minutes every day",
        "Eat breakfast",
        "Drink more water",
        "Attend a social event or outing",
        "Try mindfulness or meditation for 15 minutes",
        "Call a family member or friend",
        "Consider therapy or seek support from a professional",
        "Create a routine for self-care and follow it"
    ],
    "Moderately Severe Depression": [
        "Walk or exercise for 30 minutes daily",
        "Seek therapy or counseling",
        "Talk to a close friend or family member about your feelings",
        "Schedule a mental health check-up",
        "Consider starting an online mental health support group",
        "Start a daily gratitude or journal practice"
    ],
    "Severe Depression": [
        "Exercise daily for 30–60 minutes",
        "Seek professional therapy or counseling",
        "Reach out to a mental health hotline for support",
        "Create a daily self-care routine",
        "Connect with a therapist or counselor for ongoing support",
        "Engage in a positive activity that you've been avoiding"
    ],
    # For anxiety as well
    "Minimal Anxiety": [
        "Practice deep breathing exercises",
        "Take 10 minutes of quiet time each day",
        "Start a hobby you've been interested in",
        "Reach out to a friend and share how you’re feeling",
        "Take a 10-minute walk to clear your head",
        "Limit caffeine intake today"
    ],
    "Mild Anxiety": [
        "Exercise for 20 minutes each day",
        "Try mindfulness meditation for 10 minutes",
        "Engage in a relaxing activity you enjoy",
        "Speak with a supportive friend about your anxiety",
        "Start a positive affirmation journal",
        "Plan a small social activity to reconnect"
    ],
    "Moderate Anxiety": [
        "Exercise for 30 minutes every day",
        "Join a social activity to connect with others",
        "Seek therapy or counseling to manage anxiety",
        "Start practicing deep breathing exercises daily",
        "Limit screen time and try relaxation techniques",
        "Create a stress-relief plan and stick to it"
    ],
    "Severe Anxiety": [
        "Exercise regularly, especially outdoor activities",
        "Consult a mental health professional for support",
        "Practice mindfulness and deep breathing daily",
        "Consider cognitive behavioral therapy (CBT)",
        "Join a support group to discuss your experiences",
        "Reach out to someone you trust whenever you feel overwhelmed"
    ]
}

# User data models to track points and goal progress
class UserGoals(BaseModel):
    completed_goals: List[str] = []
    points: int = 0

# Store user goals and points (this would typically be a database, for now it's in-memory)
user_data: Dict[str, UserGoals] = {}

# Function to determine goals based on PHQ-9 score
def get_goals_for_phq9_score(score: int) -> List[str]:
    if score <= 4:
        return GOALS["Minimal Depression"]
    elif score <= 9:
        return GOALS["Mild Depression"]
    elif score <= 14:
        return GOALS["Moderate Depression"]
    elif score <= 19:
        return GOALS["Moderately Severe Depression"]
    else:
        return GOALS["Severe Depression"]

# Function to determine goals based on GAD-7 score
def get_goals_for_gad7_score(score: int) -> List[str]:
    if score <= 4:
        return GOALS["Minimal Anxiety"]
    elif score <= 9:
        return GOALS["Mild Anxiety"]
    elif score <= 14:
        return GOALS["Moderate Anxiety"]
    else:
        return GOALS["Severe Anxiety"]

@app.post("/calculate_phq9")
def calculate_phq9(request: PHQ9Request):
    if len(request.responses) != 9:
        raise HTTPException(status_code=400, detail="PHQ-9 requires exactly 9 responses.")
    
    score = sum(request.responses)
    mental_state = "Minimal Depression" if score <= 4 else \
                    "Mild Depression" if score <= 9 else \
                    "Moderate Depression" if score <= 14 else \
                    "Moderately Severe Depression" if score <= 19 else \
                    "Severe Depression"
    
    # Get goals based on PHQ-9 score
    goals = get_goals_for_phq9_score(score)
    
    return JSONResponse(status_code=200, content={"score": score, "mental_state": mental_state, "goals": goals})

@app.post("/calculate_gad7")
def calculate_gad7(request: GAD7Request):
    if len(request.responses) != 7:
        raise HTTPException(status_code=400, detail="GAD-7 requires exactly 7 responses.")
    
    score = sum(request.responses)
    anxiety_level = "Minimal Anxiety" if score <= 4 else \
                     "Mild Anxiety" if score <= 9 else \
                     "Moderate Anxiety" if score <= 14 else \
                     "Severe Anxiety"
    
    # Get goals based on GAD-7 score
    goals = get_goals_for_gad7_score(score)
    
    return JSONResponse(status_code=200, content={"score": score, "mental_state": anxiety_level, "goals": goals})

@app.post("/generate_goals")
def generate_goals(data: Dict):
    phq_score = data.get("phq9_score")
    gad_score = data.get("gad7_score")

    if phq_score is None or gad_score is None:
        raise HTTPException(status_code=400, detail="Scores missing")

    goals = []

    # Check for PHQ score range and assign goals accordingly
    if phq_score <= 4:
        goals += GOALS["Minimal Depression"]
    elif phq_score <= 9:
        goals += GOALS["Mild Depression"]
    elif phq_score <= 14:
        goals += GOALS["Moderate Depression"]
    elif phq_score <= 19:
        goals += GOALS["Moderately Severe Depression"]
    else:
        goals += GOALS["Severe Depression"]

    # Check for GAD score range and assign goals accordingly
    if gad_score <= 4:
        goals += GOALS["Minimal Anxiety"]
    elif gad_score <= 9:
        goals += GOALS["Mild Anxiety"]
    elif gad_score <= 14:
        goals += GOALS["Moderate Anxiety"]
    else:
        goals += GOALS["Severe Anxiety"]

    return {"goals": goals}



@app.post("/update_user_goals")
def update_user_goals(request: UpdateUserGoalsRequest):
    user_id = request.user_id
    completed_goals = request.completed_goals
    
    if user_id not in user_data:
        user_data[user_id] = UserGoals()

    user = user_data[user_id]
    
    points = 0
    # Iterate through all goal categories in GOALS
    for goal_category in GOALS.values():
        for goal in goal_category:
            if goal in completed_goals:
                if goal not in user.completed_goals:
                    user.completed_goals.append(goal)
                    points += 1  # Award points for each completed goal

    user.points += points
    return JSONResponse(status_code=200, content={"message": "Goals updated", "points": user.points})
