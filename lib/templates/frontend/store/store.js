import { createStore } from 'redux';
import RootReducer from '../reducer/root_reducer';
import RootMiddleware from '../middleware/root_middleware';

// Set up the default state of the store here.
const _default = {};


export default function store(state = {}){
  state = merge(_default, state);

  return createStore(
    RootReducer,
    state,
    RootMiddleware
  );
}
