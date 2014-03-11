angular.module('quizApp')

  .directive 'quiz', ->
    restrict: 'E'
    replace: true
    transclude: true
    controller: ($scope) ->
      $scope.quiz ||= {}
      $scope.quiz.response ||= {}
      @
    template: "<div class='quiz' ng-transclude></div>"

  .directive 'question', ->
    restrict: 'E'
    replace: true
    transclude: true
    controller: ($scope, $attrs) ->
      @name = $scope.$eval($attrs.name)
      @type = $scope.quiz.questions[@name].type
      $scope.quiz.response[@name] ||= {a:false,b:false,c:false,d:false}
      @
    scope: true
    template: """
      <fieldset class="question" ng-transclude ng-class="{invalid: quiz.correct[name].invalid}">
      </fieldset>
      """
    link: (scope, element, attrs, ctrl) ->
      scope.name = attrs.name

  .directive 'choice', ->
    restrict: 'A',
    replace: false,
    transclude: true,
    require: '^question'
    scope: true
    template: """
      <label class="checkbox"
         ng-class="{correct: quiz.answers[questionName].correct[answerName],
                    invalid: quiz.answers[questionName].incorrect[answerName]}">
        <input type="radio" name="{{questionName}}" ng-disabled="quiz.disabled" ng-model="quiz.response[questionName][answerName]">
        <span ng-transclude></span>
      </label>
    """
    link: (scope, element, attrs, question) ->
      scope.questionName = question.name
      scope.answerName = attrs.value

  .directive 'listElementChoice', ->
    restrict: 'E',
    replace: true,
    transclude: true,
    require: '^question'
    scope: true
    template: """
    <li>
      <label class="checkbox"
         ng-class="{correct: quiz.correct[questionName].answers[answerName].correctValue,
                    invalid: quiz.correct[questionName].answers[answerName].invalid}"
         ng-switch on="questionType">

        <input type="checkbox" name="{{questionName}}" ng-disabled="quiz.disabled" ng-model="quiz.response[questionName][answerName]"
          ng-switch-when="checkbox">

        <input type="radio" name="{{questionName}}" ng-disabled="quiz.disabled" ng-model="quiz.response[questionName][answerName]"
          ng-switch-when="radio" value="true">
      </label>
    </li>
    """
    link: (scope, element, attrs, question) ->
      scope.questionName = question.name
      scope.optionLabel= attrs.optionlabel
      scope.questionType = question.type
      scope.answerName = attrs.answername

  .directive 'newQuestionOption', ->
    restrict: 'E'
    replace: true
    transclude:false
    require: '^question'
    scope: true
    template: """
    <li class="input-group">
      <span class="input-group-addon" ng-switch on="questionType">
        <input type="checkbox" name="{{questionName}}" ng-disabled="quiz.disabled" ng-model="quiz.response[questionName][answerName]"
          ng-switch-when="checkbox">
        <input type="radio" name="{{questionName}}" ng-disabled="quiz.disabled" ng-model="quiz.response[questionName][answerName]"
          ng-switch-when="radio" value="true">
      </span>

        <input type="text" class="form-control" ng-model="quiz.questions[questionName][answerName]" placeholder="{{optionLabel}}">

      <span class="input-group-btn">
        <button type="button" class="btn btn-default" ng-click="toggleEditMode()">
          <span class="glyphicon glyphicon-edit"></span>
        </button>
        <button type="button" class="btn btn-danger" ng-click="deleteOption(questionName,answerName)">
          <span class="glyphicon glyphicon-remove"></span>
        </button>
      </span>
    </li>
    """
    link: ($scope, element, attrs, question) ->
      $scope.questionName = question.name
      $scope.optionLabel= attrs.optionlabel
      $scope.questionType = question.type
      $scope.answerName = attrs.answername

  .directive 'inlineAnswer', ->
    restrict: 'E',
    replace: true,
    transclude: false,
    require: '^question'
    scope: true
    template: """
      <input class="inline-answer" type="text" ng-disabled="quiz.disabled"
        ng-class="{invalid: quiz.correct[questionName].answers[answerName].invalid}"
        ng-model="quiz.response[questionName][answerName]">
    """
    link: (scope, element, attrs, question) ->
      scope.questionName = question.name
      scope.answerName = attrs.name
      scope.$watch 'quiz.correct[questionName].answers[answerName].correctValue', (value) ->
        attrs.$set('title', (value and "Correct answer: #{value}") or '')
