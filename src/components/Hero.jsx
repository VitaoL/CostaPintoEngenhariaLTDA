// src/components/Hero.jsx
import { useEffect, useState } from "react";
import { fetchEnterpriseData, fetchHeroCoverData } from "../mocks";

function Hero() {
  const [enterprise, setEnterprise] = useState(null);
  const [cover, setCover] = useState(null);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    Promise.all([fetchEnterpriseData(), fetchHeroCoverData()])
      .then(([enterpriseData, coverData]) => {
        setEnterprise(enterpriseData);
        setCover(coverData);
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
      <section id="inicio" className="hero-section">
        <div className="hero-overlay">
          <p>Carregando dados da empresa...</p>
        </div>
      </section>
    );
  }

  if (error) {
    return (
      <section id="inicio" className="hero-section">
        <div className="hero-overlay">
          <p style={{ color: "red" }}>
            Erro ao carregar dados da empresa: {error.toString()}
          </p>
        </div>
      </section>
    );
  }

  const backgroundImage = cover?.imageUrl
    ? `url(${cover.imageUrl})`
    : "none";

  // src/components/Hero.jsx (parte final)
  return (
    <section
      id="inicio"
      className="hero-section"
      style={{
        backgroundImage: cover?.images?.length ? "none" : backgroundImage,
      }}
    >
      {/* overlay só pro texto principal */}
      <div className="hero-overlay">
        <div className="hero-layout">
          <div className="hero-content">
            <h1>{enterprise.name}</h1>
            <p>{enterprise.shortDescription}</p>

            <button
              className="hero-button"
              onClick={() =>
                document
                  .getElementById("sobre")
                  ?.scrollIntoView({ behavior: "smooth" })
              }
            >
              Saiba Mais
            </button>
          </div>

          {cover?.images?.length && (
            <div className="hero-collage" aria-label="Apresentação de projetos">
              {cover.images.map((image, index) => (
                <div key={image} className={`hero-collage-card card-${index + 1}`}>
                  <img src={image} alt={`Projeto ${index + 1}`} />
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {cover?.caption && (
        <div className="hero-caption hero-caption-bottom">
          {cover.caption}
        </div>
      )}
    </section>
  );

}

export default Hero;
