// src/components/Portfolio.jsx
import { useEffect, useState } from "react";
import {
  fetchDeliverablesData,
  fetchServiceTypesData,
} from "../mockData";

function Portfolio() {
  const [deliverables, setDeliverables] = useState([]);
  const [types, setTypes] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    Promise.all([fetchDeliverablesData(), fetchServiceTypesData()])
      .then(([delivData, typesData]) => {
        setDeliverables(delivData);
        setTypes(typesData);
      })
      .catch((err) => {
        console.error(err);
        setError(err);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <section id="portfolio">
        <h2>Portfólio</h2>
        <p>Carregando informações...</p>
      </section>
    );
  }

  if (error) {
    return (
      <section id="portfolio">
        <h2>Portfólio</h2>
        <p style={{ color: "red" }}>
          Erro ao carregar portfólio: {error.toString()}
        </p>
      </section>
    );
  }

  return (
    <section id="portfolio">
      <h2>Portfólio e Entregáveis</h2>

      {/* ENTREGÁVEIS */}
      <div style={{ marginTop: "1.5rem", marginBottom: "2rem" }}>
        <h3>Entregáveis em projetos</h3>

        <ul style={{ listStyle: "none", padding: 0, marginTop: "0.75rem" }}>
          {deliverables.map((item) => (
            <li
              key={item.id}
              style={{
                border: "1px solid #ddd",
                borderRadius: "8px",
                padding: "0.75rem 1rem",
                marginBottom: "0.75rem",
                boxShadow: "0 1px 4px rgba(0,0,0,0.05)",
              }}
            >
              <strong>{item.code} – {item.title}</strong>
              {item.description && (
                <p
                  style={{
                    margin: "0.35rem 0 0",
                    fontSize: "0.9rem",
                    color: "#555",
                  }}
                >
                  {item.description}
                </p>
              )}
            </li>
          ))}
        </ul>
      </div>

      {/* TIPOS DE OBRAS */}
      <div>
        <h3>Tipos de obras</h3>

        <div
          style={{
            display: "flex",
            flexWrap: "wrap",
            gap: "0.75rem",
            marginTop: "0.75rem",
          }}
        >
          {types.map((type) => (
            <div
              key={type.id}
              style={{
                border: "1px solid #ddd",
                borderRadius: "999px",
                padding: "0.5rem 1rem",
                fontSize: "0.9rem",
                backgroundColor: "#fafafa",
              }}
            >
              {type.name}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

export default Portfolio;
