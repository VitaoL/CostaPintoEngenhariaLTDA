// src/components/Header.jsx
import { useEffect, useState } from "react";
import { fetchHeaderData, fetchEnterpriseData } from "../mockData";

function Header() {
  const [items, setItems] = useState([]);
  const [enterprise, setEnterprise] = useState(null);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    Promise.all([fetchHeaderData(), fetchEnterpriseData()])
      .then(([menuItems, enterpriseData]) => {
        setItems(menuItems);
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
      <header>
        <h2>Carregando empresa...</h2>
        <nav>
          <span>Carregando menu...</span>
        </nav>
      </header>
    );
  }

  if (error) {
    return (
      <header>
        <h2>Não foi possível carregar os dados da empresa</h2>
        <nav>
          <span style={{ color: "red" }}>
            Erro: {error.toString()}
          </span>
        </nav>
      </header>
    );
  }

  return (
    <header>
      <h2>{enterprise?.name}</h2>

      <nav>
        {items.map((item) => (
          <a key={item.link} href={item.link}>
            {item.name}
          </a>
        ))}
      </nav>
    </header>
  );
}

export default Header;
