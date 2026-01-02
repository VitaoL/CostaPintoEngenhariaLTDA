export const serviceTypes = [
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

export const deliverablesData = [
  {
    id: 1,
    code: "Anexo 01",
    title: "Carta de Apresentação",
    description: "Apresentação institucional e objetivos da proposta.",
  },
  {
    id: 2,
    code: "Anexo 02",
    title: "Proposta Técnica",
    description: "Documento detalhado com método, escopo e premissas.",
  },
  {
    id: 3,
    code: "Anexo 03",
    title: "Cronograma Físico",
    description: "Planejamento das etapas da obra e seus prazos.",
  },
  {
    id: 4,
    code: "Anexo 04",
    title: "Plano de SMS e Qualidade",
    description: "Diretrizes de segurança, meio ambiente e qualidade.",
  },
  {
    id: 5,
    code: "Anexo 05",
    title: "Histogramas de Equipes e Equipamentos",
    description: "Distribuição de recursos ao longo do cronograma.",
  },
  {
    id: 6,
    code: "Anexo 06",
    title: "PIT - Plano de Inspeção e Teste",
    description: "Critérios de inspeção, testes e aceitação dos serviços.",
  },
  {
    id: 7,
    code: "Anexo 08",
    title: "Índices de Produtividade",
    description: "Parâmetros usados no dimensionamento das equipes.",
  },
];

export function fetchDeliverablesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar portfólio de entregáveis");
      } else {
        resolve(deliverablesData);
      }
    }, 300);
  });
}

export function fetchServiceTypesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar tipos de obras");
      } else {
        resolve(serviceTypes);
      }
    }, 300);
  });
}
