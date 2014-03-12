angular.module('quizApp')
  .controller 'StatisticsCtrl', ($scope, $routeParams, $q, Flash, Quiz) ->
    quiz = $scope.quiz ||= {}

    $scope.status = "Loading questions. Please wait..."

    defer = $q.defer()

    defer.promise
      .then ->
        responsesResult = Quiz.loadResponses().then (responsesResult)
          #$scope.quiz.responses = responsesResult  if responsesResult?
        $scope.quiz.responses = responsesResult if responsesResult
      
      .then ->
        answersResult = Quiz.loadAnswers().then (answersResult) ->
        
        $scope.quiz.answers = answersResult if answersResult

    defer.resolve()
    
    $scope.status = null
    
#    for own qName, answers of $scope.quiz.responses

