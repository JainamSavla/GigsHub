import React, { useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import newRequest from "../../utils/newRequest";
import "./Success.scss";

const Success = () => {
  const { search } = useLocation();
  const navigate = useNavigate();
  const params = new URLSearchParams(search);
  const payment_intent = params.get("payment_intent");

  useEffect(() => {
    const makeRequest = async () => {
      try {
        await newRequest.put("/orders", { payment_intent });
        setTimeout(() => {
          navigate("/orders");
        }, 5000);
      } catch (err) {
        console.log(err);
      }
    };

    makeRequest();
  }, []);

  return (
    <div className="success">
      <div className="success-card">
        <div className="success-icon">
          <svg viewBox="0 0 52 52">
            <path d="M14 27l10 10L38 15" />
          </svg>
        </div>
        <h1>Payment Successful!</h1>
        <p>
          Your payment has been processed successfully. Thank you for your
          order!
        </p>
        <div className="redirect-info">
          <div className="spinner-small"></div>
          <span>Redirecting to orders page...</span>
        </div>
        <p style={{ marginTop: "20px", fontSize: "14px", color: "#999" }}>
          Please do not close this page
        </p>
      </div>
    </div>
  );
};

export default Success;
