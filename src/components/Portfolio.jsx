// src/components/Portfolio.jsx
import { useEffect, useState } from "react";
import {
  fetchDeliverablesData,
  fetchServiceTypesData,
} from "../mocks";

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
      <section id="portfolio" className="section-portfolio">
        <div className="section-portfolio-inner">
          <header className="section-portfolio-header">
            <h2>Portfólio e Entregáveis</h2>
            <p>Carregando informações de projetos e documentos...</p>
          </header>
        </div>
      </section>
    );
  }

  if (error) {
    return (
      <section id="portfolio" className="section-portfolio">
        <div className="section-portfolio-inner">
          <header className="section-portfolio-header">
            <h2>Portfólio e Entregáveis</h2>
            <p style={{ color: "#b91c1c" }}>
              Erro ao carregar portfólio: {error.toString()}
            </p>
          </header>
        </div>
      </section>
    );
  }

  return (
    <section id="portfolio" className="section-portfolio">
      <div className="section-portfolio-inner">
        <header className="section-portfolio-header">
          <h2>Portfólio e Entregáveis</h2>
          <p>
            Organizamos propostas técnicas e documentos que dão segurança à
            contratação e ao acompanhamento de obras. Cada anexo é preparado
            para facilitar a leitura do contratante e traduzir o escopo com
            clareza.
          </p>
        </header>

        {/* ENTREGÁVEIS */}
        <div className="portfolio-block">
          <h3 className="portfolio-subtitle">Principais entregáveis</h3>

          <ul className="deliverables-list">
            {deliverables.map((item) => (
              <li key={item.id} className="deliverable-card">
                <div className="deliverable-header">
                  <span className="deliverable-code">{item.code}</span>
                  <span className="deliverable-title">{item.title}</span>
                </div>

                {item.description && (
                  <p className="deliverable-description">
                    {item.description}
                  </p>
                )}
              </li>
            ))}
          </ul>
        </div>

        {/* TIPOS DE OBRAS */}
        <div className="portfolio-block">
          <h3 className="portfolio-subtitle">Tipos de obras</h3>

          <div className="service-types-chips">
            {types.map((type) => (
              <div key={type.id} className="service-type-chip">
                {type.name}
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

export default Portfolio;
