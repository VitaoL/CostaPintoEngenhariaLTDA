// src/components/Sobre.jsx
import { useEffect, useState } from "react";
import { fetchAboutData } from "../mocks";

function Sobre() {
  const [enterprise, setEnterprise] = useState(null);
  const [highlights, setHighlights] = useState(null);
  const [pillars, setPillars] = useState([]);
  const [audience, setAudience] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchAboutData()
      .then((aboutData) => {
        setEnterprise(aboutData.enterprise);
        setHighlights(aboutData.highlights);
        setPillars(aboutData.pillars);
        setAudience(aboutData.audience || []);
      })
      .catch((err) => {
        console.error(err);
        setError(err);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <section id="sobre" className="section-sobre">
        <div className="section-sobre-inner">
          <h2>Sobre</h2>
          <p>Carregando informações da empresa...</p>
        </div>
      </section>
    );
  }

  if (error) {
    return (
      <section id="sobre" className="section-sobre">
        <div className="section-sobre-inner">
          <h2>Sobre</h2>
          <p style={{ color: "#b91c1c" }}>
            Erro ao carregar informações da empresa: {error.toString()}
          </p>
        </div>
      </section>
    );
  }

  const name = enterprise?.name || "Costa Pinto Engenharia LTDA";

  return (
    <section id="sobre" className="section-sobre">
      <div className="section-sobre-inner">
        {/* Cabeçalho da seção */}
        <header className="section-sobre-header">
          <h2>Quem somos</h2>
          <p>
            {highlights?.whoWeAre ||
              `${name} é uma empresa dedicada à elaboração de propostas técnicas e apoio em engenharia civil.`}
          </p>
        </header>

        <div className="sobre-body">
          <div className="sobre-text-block">
            <h3>Em que acreditamos</h3>
            <p>
              {highlights?.whatWeBelieve ||
                "Acreditamos que uma proposta técnica bem estruturada é a base para uma obra segura, eficiente e com boa previsibilidade de custos e prazos."}
            </p>

            <h3>Como trabalhamos</h3>
            <ul className="sobre-pilares-lista">
              {pillars.map((pillar) => (
                <li key={pillar.id}>
                  <strong>{pillar.title}</strong>
                  <span>{pillar.text}</span>
                </li>
              ))}
            </ul>

            <div className="sobre-clientes">
              <h3>Para quem prestamos serviços</h3>
              <div className="sobre-clientes-grid">
                {audience.map((item) => (
                  <div key={item.id} className="sobre-cliente-card">
                    <strong>{item.title}</strong>
                    <span>{item.text}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="sobre-dados-empresa">
              <h3>Dados da empresa</h3>
              <p>
                <strong>Responsável técnico:</strong>{" "}
                {enterprise.representative}
              </p>
              <p>
                <strong>CNPJ:</strong> {enterprise.cnpj}
              </p>
              <p>
                <strong>Endereço:</strong> {enterprise.address}
              </p>
              <p>
                <strong>Telefone:</strong> {enterprise.phoneNumber}
              </p>
              <p>
                <strong>E-mail:</strong>{" "}
                <a href={`mailto:${enterprise.contactEmail}`}>
                  {enterprise.contactEmail}
                </a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default Sobre;
