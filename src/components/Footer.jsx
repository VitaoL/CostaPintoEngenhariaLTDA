// src/components/Footer.jsx
import { useEffect, useState } from "react";
import { fetchEnterpriseData } from "../mocks";

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
      <footer className="site-footer">
        Carregando rodapé...
      </footer>
    );
  }

  if (error) {
    return (
      <footer className="site-footer site-footer--error">
        Erro ao carregar rodapé: {error.toString()}
      </footer>
    );
  }

  return (
    <footer className="site-footer">
      <p className="site-footer__name">
        {enterprise.name}
      </p>

      {enterprise.cnpj && (
        <p className="site-footer__line">
          CNPJ: {enterprise.cnpj}
        </p>
      )}

      {enterprise.address && (
        <p className="site-footer__line">
          {enterprise.address}
        </p>
      )}

      <p className="site-footer__copyright">
        © {currentYear} {enterprise.name}. Todos os direitos reservados.
      </p>
    </footer>
  );
}

export default Footer;
