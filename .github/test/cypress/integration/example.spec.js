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

    //find the Kibana icon, navigate to it and check a kibana specific header
    cy.contains('Kibana');
    cy.request('/kibana/')
      .its('headers')
      .then((responseHeaders) => {
        expect(responseHeaders).to.have.property(
          'kbn-name',
          'kibana',
        )
      })
  })

  it('Access Echo Service', () => {
    cy.visit('/echo/')
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

    // verify the iam_auth cookie with the jwt exists
    cy.getCookie('iam_auth').should('exist')

    // verify that we are on the portal
    cy.contains('[class="page-title"]', 'Portal');

    //find the Echo icon,
    cy.contains('Echo');

    //access the echo service and verify that it went through the microgateway
    // by looking for env cookie content
    cy.request('/echo/').its('body').should('include', 'GET /echo/ HTTP/1.1').
      should('include', 'AL_ENV_REQUEST_ID');
  })

})
