// src/components/Header.jsx
import { useEffect, useState } from "react";
import { fetchHeaderData, fetchEnterpriseData } from "../mocks";

function Header() {
  const [items, setItems] = useState([]);
  const [enterprise, setEnterprise] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [menuOpen, setMenuOpen] = useState(false);

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

  const toggleMenu = () => setMenuOpen((prev) => !prev);

  if (loading) {
    return (
      <header className="site-header">
        <div className="header-content">
          <div className="header-left">
            <div className="logo-placeholder" />
            <span className="company-name">Carregando...</span>
          </div>
        </div>
      </header>
    );
  }

  if (error) {
    return (
      <header className="site-header">
        <div className="header-content">
          <div className="header-left">
            <div className="logo-placeholder" />
            <span className="company-name">
              Erro ao carregar: {error.toString()}
            </span>
          </div>
        </div>
      </header>
    );
  }

  return (
    <header className="site-header">
      <div className="header-content">
        <div className="header-left">
          <img
            src="/Logo_Costa_Pinto_Engenharia.png"
            alt="Logo Costa Pinto Engenharia"
            className="header-logo"
          />
          <span className="company-name">
            {enterprise?.name || "Costa Pinto Engenharia LTDA."}
          </span>
        </div>

        {/* Botão hamburguer (mobile) */}
        <button
          className="menu-toggle"
          type="button"
          onClick={toggleMenu}
          aria-label="Abrir menu"
        >
          ☰
        </button>

        {/* Menu desktop + mobile */}
        <nav className={`header-nav ${menuOpen ? "open" : ""}`}>
          {items.map((item) => (
            <a key={item.link} href={item.link} onClick={() => setMenuOpen(false)}>
              {item.name}
            </a>
          ))}
        </nav>
      </div>
    </header>
  );
}

export default Header;
