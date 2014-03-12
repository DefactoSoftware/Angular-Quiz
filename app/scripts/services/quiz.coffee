angular.module('quizApp')
  .factory 'Quiz', (DB, $q) ->
    answers = {}
    questions = {}
    responses = {}
    currentQuiz = {}

    quiz =
      loadQuestions: ->
        id = currentQuiz.id or 0
        return $q.when(questions[id]) if questions[id]

        DB.read("Quizes/#{id}/questions").then (data) ->
          questions[id] = data

      loadAnswers: ->
        id = currentQuiz.id or 0
        return $q.when(answers[id]) if answers[id]

        DB.read("Quizes/#{id}/answers").then (data) ->
          answers[id] = data

      loadQuiz: (id) ->
        return $q.when(currentQuiz) if currentQuiz.id is id

        DB.read("Quizes/#{id}").then (data) ->
          currentQuiz.courseId = data.courseId
          currentQuiz.id = data.id
          currentQuiz.options = data.options
          currentQuiz.title = data.title

      loadResponse: (userId) ->
        quizId = currentQuiz.id or 0
        return $q.when(responses[quizId]?[userId]) if responses[quizId]?[userId]

        DB.read("responses/#{quizId}/#{userId}").then (data) ->
          responses[quizId] = {}
          responses[quizId][userId]= data

      submitResponse: (userId, response) ->
        quizId = currentQuiz.id or 0
        DB.write("responses/#{quizId}/#{userId}", response)

      submitQuiz: (response) ->

        DB.read("Quizes").then (data) ->
          newKey = data.length
          DB.write("Quizes/#{newKey}", response)

