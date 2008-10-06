

struct schedulee
{
    int (*pf)();
    void *pv;
};


#define MAX_SCHEDULEES 100

static struct schedulee pschedule[MAX_SCHEDULEES];

static int iSchedule = 0;

int c_register_driver(void *pf, void *pv)
{
    pschedule[iSchedule].pf = pf;
    pschedule[iSchedule].pv = pv;

    iSchedule++;

    if (iSchedule >= MAX_SCHEDULEES)
    {
	return -1;
    }

    return iSchedule;
}


int c_steps(int iSteps, double dStep)
{
    int i;

    for (i = 0; i < iSteps ; i++)
    {
	double dSimulationTime = i * dStep + (1e-9);

	int j;

	for (j = 0 ; j < iSchedule ; j++)
	{
	    if (pschedule[j].pf(pschedule[j].pv, dSimulationTime) == 0)
	    {
		return(0);
	    }
	}
    }

    return(1);
}


