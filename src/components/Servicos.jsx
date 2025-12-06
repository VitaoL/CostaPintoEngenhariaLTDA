// src/components/Servicos.jsx
import { useEffect, useState } from "react";
import { fetchServicesData } from "../mockData";

function Servicos() {
  const [services, setServices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchServicesData()
      .then((data) => setServices(data))
      .catch((err) => {
        console.error(err);
        setError(err);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <section id="servicos">
        <h2>Onde já trabalhamos</h2>
        <p>Carregando serviços...</p>
      </section>
    );
  }

  if (error) {
    return (
      <section id="servicos">
        <h2>Onde já trabalhamos</h2>
        <p style={{ color: "red" }}>
          Erro ao carregar serviços: {error.toString()}
        </p>
      </section>
    );
  }

  if (!services.length) {
    return (
      <section id="servicos">
        <h2>Onde já trabalhamos</h2>
        <p>Nenhum serviço cadastrado ainda.</p>
      </section>
    );
  }

  return (
    <section id="servicos">
      <h2>Onde já trabalhamos</h2>

      <div
        style={{
          display: "flex",
          flexWrap: "wrap",
          gap: "1.5rem",
          marginTop: "1rem",
        }}
      >
        {services.map((service) => (
          <a
            key={service.id}
            href={service.link}
            target="_blank"
            rel="noreferrer"
            style={{
              flex: "1 1 calc(33.333% - 1.5rem)", // até 3 por linha
              minWidth: "220px",
              maxWidth: "320px",
              textDecoration: "none",
              border: "1px solid #ddd",
              borderRadius: "8px",
              padding: "1rem",
              boxShadow: "0 2px 6px rgba(0,0,0,0.08)",
            }}
          >
            {service.imageUrl && (
              <img
                src={service.imageUrl}
                alt={service.name}
                style={{
                  width: "100%",
                  height: "160px",
                  objectFit: "contain",
                  borderRadius: "6px",
                  marginBottom: "0.75rem",
                }}
              />
            )}

            <h3 style={{ margin: "0 0 0.5rem 0", color: "#222" }}>
              {service.name}
            </h3>

            {service.description && (
              <p style={{ margin: 0, color: "#555", fontSize: "0.9rem" }}>
                {service.description}
              </p>
            )}
          </a>
        ))}
      </div>
    </section>
  );
}

export default Servicos;
