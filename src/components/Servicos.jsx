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

            <div className="servicos-list">
              {contractors.map((company) => (
                <div key={company.id} className="servicos-card">
                  {company.imageUrl && (
                    <div className="servicos-image-wrapper">
                      <img
                        src={company.imageUrl}
                        alt={company.name}
                        className="servicos-image"
                      />
                    </div>
                  )}

                  <div className="servicos-card-text">
                    <h4>{company.name}</h4>
                    <p>{company.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="servicos-column">
            <h3>Para quem realizamos propostas</h3>
            <p className="servicos-subtitle">
              Clientes finais e segmentos em que já apresentamos propostas
              técnicas para contratação.
            </p>

            <div className="servicos-list">
              {finalClients.map((client) => (
                <div key={client.id} className="servicos-card">
                  {client.imageUrl && (
                    <div className="servicos-image-wrapper">
                      <img
                        src={client.imageUrl}
                        alt={client.name}
                        className="servicos-image"
                      />
                    </div>
                  )}

                  <div className="servicos-card-text">
                    <h4>{client.name}</h4>
                    <p>{client.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default Servicos;
