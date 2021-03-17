describe('Minikube Example Tests', () => {
  it('Access Kibana Service', () => {
    cy.visit('/kibana/')
    //we are now on the iam login page
    cy.contains('[class="iam-card-header"]', 'Login');

    //login
    cy.get('#username')
      .should('be.visible')
      .type('user')
    cy.get('#password')
      .should('be.visible')
      .type('password')

    cy.get('button[type="submit"]')
      .should('be.visible')
      .click()

    // verify that we are on the portal
    cy.contains('[class="page-title"]', 'Portal');

    //find the Kibana icon and navigate to it
    cy.contains('Kibana');
    cy.visit('/kibana/')
    //cy.contains('body#kibana-app')

    // we have to logout here
  })

  it('Access Echo Service', () => {

    //access the echo service and verify that it went through the microgateway
    // by looking for env cookie content
    cy.request('/echo/').its('body').should('include', 'GET /echo/ HTTP/1.1').
      should('include', 'AL_ENV_REQUEST_ID');
  })

})
