angular.module('quizApp')

  .controller 'LogInCtrl', ($location, Auth, Flash) ->
    self = @

    self.login = ->
      Flash.now.reset()

      self.processing = true

      success = ->
        Flash.future.success("Welcome!")
        $location.path('/')

      error = (error) ->
        Flash.now.error(error.message || error)
        self.processing = false

      Auth.login(self.email, self.password).then(success, error)
