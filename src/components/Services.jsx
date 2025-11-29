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
        <p style={{ color: "red" }}>Erro ao carregar serviços: {error.toString()}</p>
      </section>
    );
  }

  return (
    <section id="servicos">
      <h2>Serviços</h2>
      <ul>
        {services.map((service) => (
          <li key={service.id}>
            <h3>{service.name}</h3>
            {service.description && <p>{service.description}</p>}
          </li>
        ))}
      </ul>
    </section>
  );
}

export default Servicos;
