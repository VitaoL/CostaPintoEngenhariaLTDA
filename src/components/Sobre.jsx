// src/components/Sobre.jsx
import { useEffect, useState } from "react";
import { fetchEnterpriseData } from "../mockData";

function Sobre() {
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
      <section id="sobre">
        <h2>Sobre</h2>
        <p>Carregando informações...</p>
      </section>
    );
  }

  if (error) {
    return (
      <section id="sobre">
        <h2>Sobre</h2>
        <p style={{ color: "red" }}>
          Erro ao carregar informações da empresa: {error.toString()}
        </p>
      </section>
    );
  }

  return (
    <section id="sobre">
      <h2>Sobre</h2>

      <h3>{enterprise.name}</h3>

      <p>{enterprise.description}</p>

      <div style={{ marginTop: "1rem" }}>
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
          <strong>E-mail:</strong> {enterprise.contactEmail}
        </p>
      </div>
    </section>
  );
}

export default Sobre;
