import Fab from "../fab/Fab";
import { useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";

// Demo data, in case the API is not available
const demoData = [
    {
      id: 1,
      name: "Customer Satisfaction Survey",
      description: "Survey to gather customer feedback",
    },
    {
      id: 2,
      name: "Employee Engagement Survey",
      description: "Survey to gather employee feedback",
    },
    {
      id: 3,
      name: "Solar Roof Feedback Survey",
      description: "Survey to gather feedback on Solar Roof product",
    },
  ];

export const SurveyList = () => {
    const navigate = useNavigate();

    // Make a request to http://127.0.0.1:8000/api/surveys/surveys/ to get the list of surveys
    const [surveys, setSurveys] = useState([]);

    useEffect(() => {
        fetch("http://localhost:8000/api/surveys/surveys/")
            .then((response) => response.json())
            .then((data) => setSurveys(data));
    }, []);


    return (
        <div style={{ padding: "20px" }}>
            <h2 style={{ textAlign: "center" }}>Saved Surveys</h2>
            <div
                style={{
                    display: "flex",
                    justifyContent: "center",
                    gap: "40px",
                    flexWrap: "wrap",
                }}
            >
                {surveys.map((survey) => (
                    <div
                        key={survey.id}
                        style={{
                            width: "300px",
                            backgroundColor: "#e0e0e0",
                            borderRadius: "8px",
                            padding: "16px",
                            boxShadow: "0 2px 4px rgba(0, 0, 0, 0.1)",
                            display: "flex",
                            flexDirection: "column",
                            justifyContent: "space-between",
                        }}
                    >
                        <div>
                            <h3 style={{ margin: "0 0 8px" }}>{survey.name}</h3>
                            <p style={{ margin: "0 0 16px" }}>{survey.description}</p>
                        </div>
                        <div style={{ display: "flex", justifyContent: "space-between", alignSelf: "end" }}>
                            <button
                                style={{
                                    backgroundColor: "black",
                                    color: "white",
                                    border: "none",
                                    padding: "8px 16px",
                                    borderRadius: "4px",
                                    cursor: "pointer",
                                }}
                            >
                                Responses
                            </button>
                        </div>
                    </div>
                ))}
                {Fab("add", () => { navigate("/create"); })}
            </div>
        </div>
    );
};


export default SurveyList;