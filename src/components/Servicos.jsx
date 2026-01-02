// src/components/Servicos.jsx
import { useEffect, useState } from "react";
import {
  fetchContractorCompaniesData,
  fetchFinalClientsData,
} from "../mocks";

function Servicos() {
  const [contractors, setContractors] = useState([]);
  const [finalClients, setFinalClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    Promise.all([fetchContractorCompaniesData(), fetchFinalClientsData()])
      .then(([contractorData, finalClientData]) => {
        setContractors(contractorData);
        setFinalClients(finalClientData);
      })
      .catch((err) => {
        console.error(err);
        setError(err);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <section id="servicos" className="section-servicos">
        <div className="section-servicos-inner">
          <header className="section-servicos-header">
            <h2>Onde já trabalhamos</h2>
            <p>Carregando informações das obras e empresas parceiras...</p>
          </header>
        </div>
      </section>
    );
  }

  if (error) {
    return (
      <section id="servicos" className="section-servicos">
        <div className="section-servicos-inner">
          <header className="section-servicos-header">
            <h2>Onde já trabalhamos</h2>
            <p style={{ color: "#fecaca" }}>
              Erro ao carregar serviços: {error.toString()}
            </p>
          </header>
        </div>
      </section>
    );
  }

  if (!contractors.length && !finalClients.length) {
    return (
      <section id="servicos" className="section-servicos">
        <div className="section-servicos-inner">
          <header className="section-servicos-header">
            <h2>Onde já trabalhamos</h2>
            <p>Ainda não há empresas cadastradas no sistema.</p>
          </header>
        </div>
      </section>
    );
  }

  return (
    <section id="servicos" className="section-servicos">
      <div className="section-servicos-inner">
        <header className="section-servicos-header">
          <h2>Onde já trabalhamos</h2>
          <p>
            Dividimos nossa atuação entre empresas que nos contrataram e os
            clientes finais para quem elaboramos propostas vencedoras.
          </p>
        </header>

        <div className="servicos-columns">
          <div className="servicos-column">
            <h3>Onde já trabalhamos</h3>
            <p className="servicos-subtitle">
              Empresas que confiaram na Costa Pinto Engenharia para apoio
              técnico e organização de propostas.
            </p>

            <div className="servicos-list servicos-list--logos">
              {contractors.map((company) => (
                <a
                  key={company.id}
                  className="servicos-logo-card"
                  href={company.link || "#"}
                  target={company.link ? "_blank" : undefined}
                  rel={company.link ? "noreferrer" : undefined}
                  onClick={(e) => {
                    if (!company.link) e.preventDefault();
                  }}
                  aria-label={company.name}
                  title={company.name}
                >
                  <div className="servicos-logo">
                    <img src={company.imageUrl} alt={company.name} />
                  </div>
                  <div className="servicos-name">{company.name}</div>
                </a>
              ))}
            </div>

          </div>

          <div className="servicos-column">
            <h3>Para quem realizamos propostas</h3>
            <p className="servicos-subtitle">
              Clientes finais e segmentos em que já apresentamos propostas
              técnicas para contratação.
            </p>

           <div className="servicos-list servicos-list--logos">
              {finalClients.map((client) => (
                <a
                  key={client.id}
                  className="servicos-logo-card"
                  href={client.link || "#"}
                  target={client.link ? "_blank" : undefined}
                  rel={client.link ? "noreferrer" : undefined}
                  onClick={(e) => {
                    if (!client.link) e.preventDefault();
                  }}
                  aria-label={client.name}
                  title={client.name}
                >
                  <div className="servicos-logo">
                    <img src={client.imageUrl} alt={client.name} />
                  </div>
                  <div className="servicos-name">{client.name}</div>
                </a>
              ))}
            </div>

          </div>
        </div>
      </div>
    </section>
  );
}

export default Servicos;
