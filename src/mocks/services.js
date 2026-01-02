export const contractorCompaniesData = [
  {
    id: 1,
    name: "Terraplenagem Paquetá",
    description: "Contratação para apoio técnico e planejamento de obras locais.",
    imageUrl: "/aterpa.png",
    link: "",
  },
  {
    id: 2,
    name: "Construtora Horizonte",
    description: "Equipe contratada para propostas de infraestrutura urbana.",
    imageUrl: "/cowan.jpeg",
    link: "",
  },
  {
    id: 3,
    name: "Sanevia Engenharia",
    description: "Parceria em estudos e propostas para sistemas de saneamento.",
    imageUrl: "/engenhariadeobras.jpeg",
    link: "",
  },
  {
    id: 4,
    name: "ViaNorte Pavimentação",
    description: "Contratação para plano de trabalho, cronogramas e medições.",
    imageUrl: "/andrade.png",
    link: "",
  },
  {
    id: 5,
    name: "GeoMinas Infraestrutura",
    description: "Apoio em memoriais técnicos e estimativas de custos.",
    imageUrl: "/btec.jpeg",
    link: "",
  },
  {
    id: 6,
    name: "Obras Gerais LTDA",
    description: "Consultoria em planejamento, produtividade e apoio de campo.",
    imageUrl: "/barbosamelo.png",
    link: "",
  },
];

export const servicesData = contractorCompaniesData.map((company) => ({
  ...company,
  description: company.description,
}));

export function fetchContractorCompaniesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar empresas contratantes");
      } else {
        resolve(contractorCompaniesData);
      }
    }, 400);
  });
}

export function fetchServicesData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar experiência em empresas");
      } else {
        resolve(servicesData);
      }
    }, 400);
  });
}
