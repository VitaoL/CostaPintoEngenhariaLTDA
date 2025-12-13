// src/components/Servicos.jsx
import { useEffect, useState } from "react";
import { fetchServicesData } from "../mockData";

function Servicos() {
  const [services, setServices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchServicesData()
      .then((data) => setServices(data))
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

  if (!services.length) {
    return (
      <section id="servicos" className="section-servicos">
        <div className="section-servicos-inner">
          <header className="section-servicos-header">
            <h2>Onde já trabalhamos</h2>
            <p>Ainda não há obras cadastradas no sistema.</p>
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
            Algumas das empresas e obras em que a Costa Pinto Engenharia LTDA
            prestou serviços de engenharia, consultoria e apoio técnico.
          </p>
        </header>

        <div className="services-list">
          {services.map((service) => (
            <a
              key={service.id}
              href={service.link}
              target="_blank"
              rel="noreferrer"
              className="service-card"
            >
              {service.imageUrl && (
                <div className="service-image-wrapper">
                  <img
                    src={service.imageUrl}
                    alt={service.name}
                    className="service-image"
                  />
                </div>
              )}

              <h3 className="service-title">{service.name}</h3>

              {/* {service.description && (
                <p className="service-description">
                  {service.description}
                </p>
              )} */}
            </a>
          ))}
        </div>
      </div>
    </section>
  );
}

export default Servicos;
