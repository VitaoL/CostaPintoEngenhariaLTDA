// src/components/Contato.jsx
import { useEffect, useState } from "react";
import { fetchEnterpriseData } from "../mockData";

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
      <section id="contato">
        <h2>Contato</h2>
        <p>Carregando informações de contato...</p>
      </section>
    );
  }

  if (error) {
    return (
      <section id="contato">
        <h2>Contato</h2>
        <p style={{ color: "red" }}>
          Erro ao carregar contato: {error.toString()}
        </p>
      </section>
    );
  }

  // se você colocou whatsappNumber no mockData:
  const whatsappNumber = enterprise.whatsappNumber || "5531988884422";

  const whatsappLink = `https://wa.me/${whatsappNumber}?text=${encodeURIComponent(
    "Olá, vi o site da Costa Pinto Engenharia LTDA e gostaria de mais informações."
  )}`;

  return (
    <section id="contato">
      <h2>Contato</h2>

      <p>
        <strong>Telefone:</strong> {enterprise.phoneNumber}
      </p>
      <p>
        <strong>E-mail:</strong>{" "}
        <a href={`mailto:${enterprise.contactEmail}`}>
          {enterprise.contactEmail}
        </a>
      </p>
      <p>
        <strong>Endereço:</strong> {enterprise.address}
      </p>

      <button
        type="button"
        onClick={() => window.open(whatsappLink, "_blank")}
        style={{
          marginTop: "1rem",
          padding: "0.75rem 1.5rem",
          borderRadius: "999px",
          border: "none",
          cursor: "pointer",
          fontWeight: "bold",
        }}
      >
        Falar no WhatsApp
      </button>
    </section>
  );
}

export default Contato;
