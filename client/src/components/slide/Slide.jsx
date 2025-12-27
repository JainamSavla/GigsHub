import React from "react";
import "./Slide.scss";
import Slider from "infinite-react-carousel";

const Slide = ({ children, slidesToShow, arrowsScroll }) => {
  const CustomArrow = ({ type, onClick, isEdge }) => {
    const pointer = type === "PREV" ? "←" : "→";
    return (
      <button
        onClick={onClick}
        disabled={isEdge}
        style={{
          background: "transparent",
          border: "none",
          fontSize: "2rem",
          cursor: isEdge ? "default" : "pointer",
          color: isEdge ? "#ccc" : "#1dbf73",
          padding: "0 10px",
        }}
      >
        {pointer}
      </button>
    );
  };

  return (
    <div className="slide">
      <div className="container">
        <Slider
          slidesToShow={slidesToShow}
          arrowsScroll={arrowsScroll}
          prevArrow={<CustomArrow type="PREV" />}
          nextArrow={<CustomArrow type="NEXT" />}
        >
          {children}
        </Slider>
      </div>
    </div>
  );
};

export default Slide;
