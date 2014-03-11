angular.module('quizApp', ['ng-firebase', 'ng-firebase-simple-login'])

  .constant('FIREBASE_URL', '@@FIREBASE_URL')

  .config ($routeProvider) ->
    requireCurrentUser = (Auth) ->
      Auth.requestCurrentUser()
    requireCurrentUser.$inject = ['Auth'] # help the minifiers

    $routeProvider
      .when '/',
        templateUrl: 'views/quiz.html'
        controller: 'QuizCtrl'
        resolve:
          currentUser: requireCurrentUser

      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LogInCtrl'
        controllerAs: 'ctrl'

      .when '/signup',
        templateUrl: 'views/signup.html'
        controller: 'SignUpCtrl'
        controllerAs: 'ctrl'

      .when '/quiz/new',
        templateUrl: 'views/newQuiz.html'
        controller: 'CreateQuizCtrl'
        resolve:
          currentUser: requireCurrentUser

      .when '/quiz/:quizId',
        templateUrl: 'views/quiz.html'
        controller: 'QuizCtrl'
        resolve:
          currentUser: requireCurrentUser

      .when '/statistics',
        templateUrl: 'views/statistics.html'
        controller: 'StatisticsCtrl'
        controllerAs: 'StatisticsCtrl'


      .otherwise
        redirectTo: '/'
