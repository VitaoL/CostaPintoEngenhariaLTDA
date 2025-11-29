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
      <section id="inicio">
        <p>Carregando dados da empresa...</p>
      </section>
    );
  }

  if (error) {
    return (
      <section id="inicio">
        <p style={{ color: "red" }}>
          Erro ao carregar dados da empresa: {error.toString()}
        </p>
      </section>
    );
  }

  return (
    <section id="inicio">
      <h1>{enterprise.name}</h1>
      <p>{enterprise.shortDescription}</p>

      <button
        onClick={() =>
          document
            .getElementById("sobre")
            ?.scrollIntoView({ behavior: "smooth" })
        }
      >
        Saiba Mais
      </button>
    </section>
  );
}

export default Hero;
