angular.module('quizApp')
  .controller 'CreateQuizCtrl', ($scope, $routeParams, currentUser, Quiz, Flash) ->
    quiz = $scope.quiz ||= {
      description: "This is the quiz description"
      answers: {}
      questions: {}
    }

    $scope.newQuestion = ->
      newQuestionCount = "" + (Object.keys(quiz.questions).length + 1)
      questionId =  'q'+ '000'.slice(0, 3 - newQuestionCount.length) + newQuestionCount
      quiz.questions[questionId] = {}
      quiz.questions[questionId] =
        options:
          a: "option a"
          b: "option b"
          c: "option c"
          d: "option d"
        question: "new question?"
        type: "radio"
      quiz.answers[questionId] =
        a:false
        b:false
        c:false
        d:false
      quiz.ready = true

    $scope.saveQuiz = ->
      $scope.quiz = quiz

    $scope.deleteOption = (questionName, answerName) ->
      quiz = $scope.quiz
      delete quiz.questions[@questionName].options[@answerName]
      delete quiz.answers[@questionName]
      delete quiz.questions[@questionName] if not Object.keys(quiz.questions[@questionName].options).length

