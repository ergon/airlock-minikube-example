describe('Minikube Example Tests', () => {
  it('Access Kibana Service', () => {
    cy.visit('/kibana/')
    //we are now on the iam login page
    cy.contains('[class="iam-card-header"]', 'Login');

  })

})
