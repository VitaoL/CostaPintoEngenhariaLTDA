// src/components/Contato.jsx
import { useEffect, useState } from "react";
import { fetchEnterpriseData } from "../mocks";

function Contato() {
  const [enterprise, setEnterprise] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchEnterpriseData()
      .then((data) => setEnterprise(data))
      .catch((err) => {
        console.error(err);
        setError(err);
      })
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <section id="contato" className="section-contato">
        <div className="section-contato-inner">
          <header className="section-contato-header">
            <h2>Contato</h2>
            <p>Carregando informações de contato...</p>
          </header>
        </div>
      </section>
    );
  }

  if (error) {
    return (
      <section id="contato" className="section-contato">
        <div className="section-contato-inner">
          <header className="section-contato-header">
            <h2>Contato</h2>
            <p style={{ color: "#b91c1c" }}>
              Erro ao carregar contato: {error.toString()}
            </p>
          </header>
        </div>
      </section>
    );
  }

  // se quiser, pode colocar isso direto no mock como whatsappNumber
  const whatsappNumber = enterprise.whatsappNumber || "5531988884422";

  const whatsappLink = `https://wa.me/${whatsappNumber}?text=${encodeURIComponent(
    "Olá, vi o site da Costa Pinto Engenharia LTDA e gostaria de mais informações."
  )}`;

  return (
    <section id="contato" className="section-contato">
      <div className="section-contato-inner">
        <header className="section-contato-header">
          <h2>Contato</h2>
          <p>
            Entre em contato para discutir propostas técnicas, apoio em
            licitações ou dúvidas sobre os serviços de engenharia.
          </p>
        </header>

        <div className="contact-grid">
          {/* Bloco com dados de contato */}
          <div className="contact-card">
            <h3>Dados da empresa</h3>

            <p>
              <strong>Telefone:</strong> {enterprise.phoneNumber}
            </p>
            <p>
              <strong>E-mail:</strong>{" "}
              <a href={`mailto:${enterprise.contactEmail}`}>
                {enterprise.contactEmail}
              </a>
            </p>
            {/* <p>
              <strong>Endereço:</strong> {enterprise.address}
            </p> */}
          </div>

          {/* Bloco com ações (WhatsApp) */}
          <div className="contact-actions">
            <p className="contact-highlight">
              Atendimento preferencial via WhatsApp.
            </p>

            <button
              type="button"
              className="whatsapp-button"
              onClick={() => window.open(whatsappLink, "_blank")}
            >
              <img
                src="/whats.jpg"
                alt="WhatsApp"
                className="whatsapp-icon"
              />
              Falar no WhatsApp
            </button>

            <p className="contact-note">
              Clique no botão para iniciar a conversa diretamente com a Costa
              Pinto Engenharia LTDA.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}

export default Contato;
