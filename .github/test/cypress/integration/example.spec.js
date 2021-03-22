describe('Minikube Example Tests', () => {
  it('Access IAM portal', () => {
    cy.visit('/')
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

    //verify that both kibana and echo service are there
    cy.contains('Kibana')
      .should('be.visible')
    cy.contains('Echo')
      .should('be.visible')
  })

  it('Access IAM admin app', () => {
    cy.visit('/auth-admin')
    //we are now on the iam login page
    cy.contains('iam-authentication-page', 'Airlock IAM');

    //login
    cy.get('#username')
      .should('be.visible')
      .type('admin')
    cy.get('#password')
      .should('be.visible')
      .type('password')

    cy.get('button[type="submit"]#loginButton')
      .should('be.visible')
      .click()

    // verify that we are in the admin app (check logs link)
    cy.contains('a#menuLogs', 'Logs');
  })

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

    // verify the url
    cy.location().should((loc) => {
      expect(loc.hostname).to.eq('host.docker.internal')
      expect(loc.pathname).to.contain('/kibana/')
      expect(loc.protocol).to.eq('https:')
      expect(loc.toString()).to.contain('https://host.docker.internal/kibana/')
    })
  })

  it.skip('Access Echo Service', () => {
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

    // verify the url
    cy.location().should((loc) => {
      expect(loc.hostname).to.eq('host.docker.internal')
      expect(loc.pathname).to.contain('/echo/')
      expect(loc.protocol).to.eq('https:')
      expect(loc.toString()).to.contain('https://host.docker.internal/echo/')
    })

    cy.document().its('contentType').should('eq', 'text/plain')

    // by looking for env cookie content
    cy.getCookie('iam_auth').should('exist');
  })

})
