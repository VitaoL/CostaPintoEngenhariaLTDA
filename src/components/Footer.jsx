// src/components/Footer.jsx
import { useEffect, useState } from "react";
import { fetchEnterpriseData } from "../mockData";

function Footer() {
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

  const currentYear = new Date().getFullYear();

  if (loading) {
    return (
      <footer
        style={{
          marginTop: "2rem",
          padding: "1rem",
          borderTop: "1px solid #ddd",
          textAlign: "center",
          fontSize: "0.85rem",
        }}
      >
        Carregando rodapé...
      </footer>
    );
  }

  if (error) {
    return (
      <footer
        style={{
          marginTop: "2rem",
          padding: "1rem",
          borderTop: "1px solid #ddd",
          textAlign: "center",
          fontSize: "0.85rem",
          color: "red",
        }}
      >
        Erro ao carregar rodapé: {error.toString()}
      </footer>
    );
  }

  return (
    <footer
      style={{
        marginTop: "2rem",
        padding: "1rem",
        borderTop: "1px solid #ddd",
        textAlign: "center",
        fontSize: "0.85rem",
      }}
    >
      <p style={{ margin: 0, fontWeight: "bold" }}>
        {enterprise.name}
      </p>

      {enterprise.cnpj && (
        <p style={{ margin: "0.15rem 0" }}>
          CNPJ: {enterprise.cnpj}
        </p>
      )}

      {enterprise.address && (
        <p style={{ margin: "0.15rem 0" }}>
          {enterprise.address}
        </p>
      )}

      <p style={{ margin: "0.4rem 0 0" }}>
        © {currentYear} {enterprise.name}. Todos os direitos reservados.
      </p>
    </footer>
  );
}

export default Footer;
