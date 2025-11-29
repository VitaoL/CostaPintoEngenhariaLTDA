// ainda em mockData.js

export const servicesData = [
  {
    id: 1,
    name: "Obras Rodoviárias",
    description:
      "Terraplenagem, viadutos, contenções, pavimentações e serviços complementares.",
  },
  {
    id: 2,
    name: "Obras Industriais",
    description: "Projetos e execução de obras industriais.",
  },
  {
    id: 3,
    name: "Obras de Saneamento",
    description: "ETA, ETE, elevatórias e adutoras.",
  },
  {
    id: 4,
    name: "Portos e Aeroportos",
    description: "Infraestrutura para portos e aeroportos.",
  },
  {
    id: 5,
    name: "Edificações Civis",
    description: "Edificações residenciais, comerciais e institucionais.",
  },
  {
    id: 6,
    name: "Mineração",
    description: "Obras e estruturas ligadas ao setor de mineração.",
  },
  {
    id: 7,
    name: "Barragens",
    description: "Projetos e execução de barragens.",
  },
];

export function fetchServicesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar serviços");
      } else {
        resolve(servicesData);
      }
    }, 400);
  });
}
