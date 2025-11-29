// src/mockData.js

// TIPOS de serviço (se você quiser usar em outra seção, tipo "O que fazemos")
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

// OBRAS / LOCAIS onde ele já trabalhou – usado no carrossel
export const servicesData = [
  {
    id: 1,
    name: "Obra Rodoviária – BR-381",
    description: "Execução de obras de contenção e pavimentação.",
    imageUrl: "/imagens/obra-381.jpg",
    link: "https://maps.google.com/...",
  },
  {
    id: 2,
    name: "Estação de Tratamento de Água – ETA X",
    description: "Projeto e execução de obras de saneamento.",
    imageUrl: "/imagens/eta-x.jpg",
    link: "https://...",
  },
  {
    id: 3,
    name: "Barragem Y",
    description: "Serviços de engenharia para barragem.",
    imageUrl: "/imagens/barragem-y.jpg",
    link: "https://...",
  },
  // adiciona mais aqui
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

export const enterpriseData = {
  name: "Costa Pinto Engenharia LTDA",
  shortDescription: "Prestação de serviços de Proposta Técnica e Engenharia Civil.",
  description:
    "A Costa Pinto Engenharia LTDA atua na área de construção civil e consultoria em obras de construção pesada, com experiência na elaboração de proposta técnica e plano de trabalho.",
  cnpj: "34.887.466/0001-72",
  address: "Rua José Rothéia, 87 - Paquetá, Belo Horizonte - MG, 31.330-632",
  representative: "Fernando Guimarães Costa Pinto",
  contactEmail: "fernandoguimaraesc811@gmail.com",
  phoneNumber: "(31) 98888-4422",
};

export function fetchEnterpriseData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar dados da empresa");
      } else {
        resolve(enterpriseData);
      }
    }, 300);
  });
}

export function fetchHeaderData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar o menu");
      } else {
        resolve([
          { name: "Início", link: "#inicio" },
          { name: "Sobre", link: "#sobre" },
          { name: "Serviços", link: "#servicos" },
          { name: "Portfólio", link: "#portfolio" },
          { name: "Contato", link: "#contato" },
        ]);
      }
    }, 500);
  });
}
