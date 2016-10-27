import { connect } from 'react-redux';
//import the actions here
//

const mapStateToProps = ({ session }, ownProps) => {
  let errorType = "logIn";
  let formType = "Log In";
  if(ownProps.route.path === "sign-up"){
    formType = "Sign Up";
    errorType = "signUp";
  }

  return({
    formType,
    errors: session.forms[errorType].errors
  });
};

const mapDispatchToProps = (dispatch, ownProps) => {
  let actionCreator = login;
  if(ownProps.route.path === "sign-up"){
    actionCreator = signup;
  }

  return({
    process: (user, cb) => dispatch(actionCreator(user, cb))
  });
};

export default connect(
  mapStateToProps, mapDispatchToProps
)(SessionForm);
