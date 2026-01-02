export const enterpriseData = {
  name: "Costa Pinto Engenharia LTDA",
 shortDescription:
  "Soluções em engenharia civil com foco em qualidade técnica, organização e segurança para sua obra.",

description:
  "A Costa Pinto Engenharia oferece soluções completas em planejamento, propostas técnicas e apoio à execução de obras civis. Atuamos com foco em qualidade técnica, organização dos processos e comunicação clara, garantindo maior segurança, controle e previsibilidade para nossos clientes em todas as etapas do projeto.",

  cnpj: "34.887.466/0001-72",
  address: "Rua José Rothéia, 87 - Paquetá, Belo Horizonte - MG, 31.330-632",
  representative: "Fernando Guimarães Costa Pinto",
  contactEmail: "fernandoguimaraesc811@gmail.com",
  phoneNumber: "(31) 98888-4422",
  whatsappNumber: "5531988884422",
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
