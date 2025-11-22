// mockData.js

export const enterpriseData = {
  name: "Costa Pinto Engenharia LTDA",
  description: "Especializada em soluções de engenharia civil e construção.",
  contactEmail: "fernandoGuimaeres@hotmail.com",
  phoneNumber: "(11) 98765-4321",
  address: "Rua José Rotheia 87, Jardim Paqueta, Belo Horizonte, MG, Brasil",
};

export function fetchEnterpriseData() {
  return new Promise((resolve, reject) => {
    const success = true;

    setTimeout(() => {
      if (!success) {
        reject("Failed to load enterprise data");
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
        reject("Failed to load header data");
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
