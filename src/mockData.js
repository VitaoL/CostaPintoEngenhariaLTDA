// src/mockData.js

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

// “Fake API” da empresa
export function fetchEnterpriseData() {
  return new Promise((resolve, reject) => {
    const success = true; // coloca false pra testar erro

    setTimeout(() => {
      if (!success) {
        reject("Falha ao carregar dados da empresa");
      } else {
        resolve(enterpriseData); // manda o objeto inteiro
      }
    }, 300);
  });
}

// Menu
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
