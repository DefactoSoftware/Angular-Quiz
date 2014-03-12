angular.module('quizApp')
  .controller 'CreateQuizCtrl', ($scope, $routeParams, currentUser, Quiz, Flash) ->
    quiz = $scope.quiz ||= {
      description: "This is the quiz description"
      answers: {}
      questions: {}
    }

    $scope.newQuestion = (kindOfQuestion) ->
      newQuestionCount = "" + (Object.keys(quiz.questions).length + 1)
      questionId =  'q'+ '000'.slice(0, 3 - newQuestionCount.length) + newQuestionCount
      quiz.questions[questionId] = {}
      quiz.questions[questionId] =
        options:
          a: ""
        keys: ["a"]
        question: ""
        type: kindOfQuestion
      quiz.answers[questionId] =
        a:false
      quiz.ready = true

    $scope.newOption = (questionId) ->
      newOptionId = String.fromCharCode(
        Object.keys(
          quiz.questions[questionId].options
        ).sort().reverse()[0].charCodeAt(0)+1
      )
      quiz.questions[questionId].options[newOptionId] = ""
      quiz.answers[questionId][newOptionId] = false
      quiz.questions[questionId].keys.push(newOptionId)

    $scope.saveQuiz = ->
      delete quiz.response
      delete quiz.ready
      quiz = angular.toJson(quiz)
      quiz = angular.fromJson(quiz)
      $scope.processing = true
      Flash.now.reset()

      succBack = ->
        Flash.now.success "Thanks for submitting the quiz!"
        quiz.disabled = true

      errBack = (error) ->
        Flash.now.error "Failed to save the quiz: #{error}"

      Quiz.submitQuiz(quiz).then(succBack, errBack)

      null


    $scope.deleteOption = (questionName, answerName) ->
      quiz = $scope.quiz
      delete quiz.questions[@questionName].options[@answerName]
      delete quiz.answers[@questionName][@answerName]
      keys = quiz.questions[@questionName].keys
      $scope.quiz.questions[@questionName].keys = (key for key in keys when key != @answerName)
      delete quiz.questions[@questionName] if not Object.keys(quiz.questions[@questionName].options).length

