
#ifndef NUKE
#define NUKE

#define LEG_COUNT   6

/* Leg dimensions */
#define L_COXA      55  // MM distance from coxa servo to femur servo
#define L_FEMUR     66 // MM distance from femur servo to tibia servo
#define L_TIBIA    135 // MM distance from tibia servo to foot

/* Leg IDs */
#define LEFT_FRONT     0
#define RIGHT_FRONT    1
#define LEFT_MIDDLE    2
#define RIGHT_MIDDLE   3
#define LEFT_REAR      4
#define RIGHT_REAR     5

/* Servo IDs */
#define LF_COXA    1
#define LF_FEMUR   3
#define LF_TIBIA   5
#define RF_COXA    2
#define RF_FEMUR   4
#define RF_TIBIA   6
#define LM_COXA   13
#define LM_FEMUR  15
#define LM_TIBIA  17
#define RM_COXA   14
#define RM_FEMUR  16
#define RM_TIBIA  18
#define LR_COXA    7
#define LR_FEMUR   9
#define LR_TIBIA  11
#define RR_COXA    8
#define RR_FEMUR  10
#define RR_TIBIA  12


/* A leg position request */
typedef struct{
  int x;
  int y;
  int z;
} ik_req_t;

/* Servo ouptut values */
typedef struct{
  double coxa;
  double femur;
  double tibia;
} ik_sol_t;

/* For the inverse of legIk */
typedef struct{
  double X;
  double Y;
  double Z;
} inv_ik_sol_t;

/* Standard positions */
extern ik_req_t endpoints[LEG_COUNT];



extern BioloidController bioloid;


/* My parameters */
extern int x[6];
extern int y[6];
extern int z[6];
extern int trantime;
extern int xr[6];
extern int yr[6];
extern int zr[6];
extern double test;
extern int leglowering[6];


// Functions

/* convert radians to a dynamixel servo offset */
double radToservo(double rads);

/* convert dynamixel servo offset to radians. */
double servoTorad(double val);

/* given our leg offset (x,y,z) from the coxa point, calculate servo values */
ik_sol_t legIK(double X, double Y, double Z);

/* given our servo values, calculate leg offset (x,y,z) from the coxa point */
inv_ik_sol_t inv_legIK(double coxa, double femur, double tibia);

/* setup the starting positions of the legs. */
void setupIK();

/* compute the servo values to actuate from the endpoints coordinates */
void doAF();

/* read the coordinates of the endpoints from servo values */
void readAF();

#endif
