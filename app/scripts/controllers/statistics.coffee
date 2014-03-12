angular.module('quizApp')
  .controller 'StatisticsCtrl', ($scope, $routeParams, $q, Flash, Quiz) ->
    quiz = $scope.quiz ||= {}
    quizId = $routeParams.quizId ||= 0
    
    $scope.status = "Loading questions. Please wait..."
    
    Quiz.loadQuiz(quizId)
    .then (quizResult) ->
      if quizResult?
        $scope.quiz.description = quizResult.description
        $scope.quiz.options = quizResult.options
        $scope.quiz.title = quizResult.title
      $scope.status = null

    .then ->
      Quiz.loadResponses(quizId).then (responsesResult) ->
        if responsesResult?
          quiz.responses = responsesResult
        quiz.numberOfResponders = Object.keys(quiz.responses).length

    .then ->
      Quiz.loadQuestions(quizId).then (questionsResult) ->
        if questionsResult?
          quiz.questions = questionsResult

    .then ->
      Quiz.loadAnswers(quizId).then (answersResult) ->
        if answersResult?
          quiz.answers = answersResult
        quiz.ready = true

      .then ->
        quiz.correct = {}
        for responder, response of quiz.responses
          for own qName, answers of response
            qq = quiz.correct[qName] =
              answers: {}
            isGoodAnswer = true
            for own aName, correctValue of quiz.answers[qName]
              aValue = answers[aName]
              correct = correctValue == aValue
              if not correct
                qq.invalid = true
                isGoodAnswer = false

            if isGoodAnswer
              if quiz.questions[qName].correctNumber?
                quiz.questions[qName].correctNumber = quiz.questions[qName].correctNumber + 1
              else
                quiz.questions[qName].correctNumber = 1
              if quiz.totalCorrectNumber?
                quiz.totalCorrectNumber = quiz.totalCorrectNumber + 1
              else
                quiz.totalCorrectNumber = 1
            else
              if quiz.questions[qName].wrongNumber?
                quiz.questions[qName].wrongNumber = quiz.questions[qName].wrongNumber + 1
              else
                quiz.questions[qName].wrongNumber = 1
              if quiz.totalWrongNumber?
                quiz.totalWrongNumber = quiz.totalWrongNumber + 1
              else
                quiz.totalWrongNumber = 1

