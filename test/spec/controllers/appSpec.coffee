describe 'Controller: AppCtrl', ->

  beforeEach(module('quizApp'));

  AppCtrl = null
  scope = null
  location = null
  Auth = null

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new();
    location = jasmine.createSpyObj('location', ['path'])
    Auth = jasmine.createSpyObj('Auth', ['logout'])
    AppCtrl = $controller 'AppCtrl', $scope: scope, $location: location, Auth: Auth

  describe 'Auth change notifications', ->
    user = null

    beforeEach ->
      user = {}
      scope.$broadcast 'authStatusChanged', user

    it 'should assign current user to the scope', ->
      expect(scope.currentUser).toBe(user)

  describe 'when not authenticated', ->
    beforeEach -> scope.$broadcast '$routeChangeError', null, null, reason: 'ACCESS_DENIED'

    it 'should redirect to login page', ->
      expect(location.path).toHaveBeenCalledWith('/login')

  describe 'logout', ->
    beforeEach -> scope.logout()

    it 'should log out using the authentication service', ->
      expect(Auth.logout).toHaveBeenCalled()

    it 'should redirect to login page', ->
      expect(location.path).toHaveBeenCalledWith('/login')
