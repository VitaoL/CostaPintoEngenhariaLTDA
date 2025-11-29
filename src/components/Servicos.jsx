// src/components/Servicos.jsx
import { useEffect, useState } from "react";
import { fetchServicesData } from "../mockData";

function Servicos() {
  const [services, setServices] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);

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

  const handlePrev = () => {
    setCurrentIndex((prev) =>
      prev === 0 ? services.length - 1 : prev - 1
    );
  };

  const handleNext = () => {
    setCurrentIndex((prev) =>
      prev === services.length - 1 ? 0 : prev + 1
    );
  };

  if (loading) {
    return (
      <section id="servicos">
        <h2>Serviços</h2>
        <p>Carregando serviços...</p>
      </section>
    );
  }

  if (error) {
    return (
      <section id="servicos">
        <h2>Serviços</h2>
        <p style={{ color: "red" }}>
          Erro ao carregar serviços: {error.toString()}
        </p>
      </section>
    );
  }

  if (!services.length) {
    return (
      <section id="servicos">
        <h2>Serviços</h2>
        <p>Nenhum serviço cadastrado ainda.</p>
      </section>
    );
  }

  const currentService = services[currentIndex];

  return (
    <section id="servicos">
      <h2>Onde já trabalhamos</h2>

      <div className="carousel">
        <button type="button" onClick={handlePrev}>
          ◀
        </button>

        <a
          href={currentService.link}
          target="_blank"
          rel="noreferrer"
          className="carousel-item"
        >
          {currentService.imageUrl && (
            <img
              src={currentService.imageUrl}
              alt={currentService.name}
              style={{ maxWidth: "300px", display: "block" }}
            />
          )}

          <h3>{currentService.name}</h3>

          {currentService.description && <p>{currentService.description}</p>}

          <small>Clique para saber mais</small>
        </a>

        <button type="button" onClick={handleNext}>
          ▶
        </button>
      </div>

      <p>
        {currentIndex + 1} / {services.length}
      </p>
    </section>
  );
}

export default Servicos;
