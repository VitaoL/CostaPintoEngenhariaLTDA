// src/components/Hero.jsx
import { useEffect, useState } from "react";
import { fetchEnterpriseData } from "../mockData";

function Hero() {
  const [enterprise, setEnterprise] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchEnterpriseData()
      .then((enterpriseData) => {
        setEnterprise(enterpriseData);
      })
      .catch((err) => {
        console.error(err);
        setError(err);
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  if (loading) {
    return (
      <section id="inicio" className="hero-section">
        <div className="hero-overlay">
          <p>Carregando dados da empresa...</p>
        </div>
      </section>
    );
  }

  if (error) {
    return (
      <section id="inicio" className="hero-section">
        <div className="hero-overlay">
          <p style={{ color: "red" }}>
            Erro ao carregar dados da empresa: {error.toString()}
          </p>
        </div>
      </section>
    );
  }
  return (
    <section id="inicio" className="hero-section">
      <div className="hero-overlay">
        <div className="hero-content">
          <h1>{enterprise.name}</h1>
          <p>{enterprise.shortDescription}</p>

          <button
            className="hero-button"
            onClick={() =>
              document
                .getElementById("sobre")
                ?.scrollIntoView({ behavior: "smooth" })
            }
          >
            Saiba Mais
          </button>
        </div>

        <div className="hero-caption">
          Aeroporto Internacional Afonso Pena – obra executada por nós em 2000
        </div>
      </div>
    </section>
  );
}

export default Hero;
