const asyncHandler = (fn) => {
  return async (req, res, next) => {
      try {
          await fn(req, res, next);
      } catch (error) {
          res.status(error.statusCode || 500).json({
              status: "fail",
              message: error.message || "Something went wrong "+error,
          })
      }
  };
};

export {asyncHandler}