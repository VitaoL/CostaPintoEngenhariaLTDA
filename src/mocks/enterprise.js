export const enterpriseData = {
  name: "Costa Pinto Engenharia LTDA",
  shortDescription:
    "Engenharia civil familiar, com foco em propostas técnicas claras e apoio à execução.",
  description:
    "Somos uma empresa familiar de pequeno porte, em fase de crescimento, que acredita no cuidado com cada proposta. Atuamos com planejamento, organização e apoio técnico para obras civis, sempre com proximidade, transparência e respeito às necessidades do cliente.",
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
